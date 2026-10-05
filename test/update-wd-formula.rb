require "fileutils"
require "open3"
require "tmpdir"
require "yaml"

root = File.expand_path("..", __dir__)
workflow = YAML.load_file(File.join(root, ".github/workflows/update-formula.yml"))
step = workflow.fetch("jobs").fetch("update").fetch("steps").find do |entry|
  entry["name"] == "Update formula"
end
script = step.fetch("run")
original = File.read(File.join(root, "Formula/wd.rb"))
original_checksums = original.scan(/sha256 "([^"]+)"/).flatten
raise "Expected four platform checksums" unless original_checksums.length == 4

mac_checksums = ["a" * 64, "b" * 64]
linux_checksums = ["c" * 64, "d" * 64]
scenarios = {
  "all four platform checksums" => [linux_checksums, mac_checksums + linux_checksums],
  "legacy macOS-only dispatch" => [["", ""], mac_checksums + original_checksums.last(2)],
}

scenarios.each do |name, (linux_inputs, expected_checksums)|
  Dir.mktmpdir("wd-formula-test-") do |directory|
    FileUtils.mkdir_p(File.join(directory, "Formula"))
    formula_path = File.join(directory, "Formula/wd.rb")
    File.write(formula_path, original)
    env = {
      "VERSION" => "9.9.9",
      "ARM64_SHA" => mac_checksums[0],
      "X64_SHA" => mac_checksums[1],
      "LINUX_ARM64_SHA" => linux_inputs[0],
      "LINUX_X64_SHA" => linux_inputs[1],
    }
    stdout, stderr, status = Open3.capture3(
      env, "bash", "-e", "-o", "pipefail", "-c", script, chdir: directory
    )
    raise "#{name}: #{stdout}#{stderr}" unless status.success?

    expected = original.sub(/version "[^"]+"/, 'version "9.9.9"')
    index = 0
    expected = expected.gsub(/sha256 "[^"]+"/) do
      checksum = expected_checksums.fetch(index)
      index += 1
      "sha256 \"#{checksum}\""
    end
    raise "#{name}: unexpected formula changes" unless File.read(formula_path) == expected

    puts "Passed: #{name}"
  end
end
