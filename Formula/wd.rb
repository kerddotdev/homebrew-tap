class Wd < Formula
  desc "Workspace Director - fast project navigation CLI"
  homepage "https://github.com/kerddotdev/wd"
  version "1.4.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kerddotdev/wd/releases/download/v#{version}/wd-macos-arm64.tar.gz"
      sha256 "c3b1460c09bb023468633aace889d17b022634bbafb283994d9f49115afa7c48"
    else
      url "https://github.com/kerddotdev/wd/releases/download/v#{version}/wd-macos-x64.tar.gz"
      sha256 "1b579fb79c35c3c3105eb6774483e356a91c827621f84a443ff7f749180ae3e7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kerddotdev/wd/releases/download/v#{version}/wd-linux-arm64.tar.gz"
      sha256 "4fba4ea7802cb931a6e23cf030f56cbf95e483b607f9f80817ee525d02966845"
    else
      url "https://github.com/kerddotdev/wd/releases/download/v#{version}/wd-linux-x64.tar.gz"
      sha256 "4ace602edfab1dcbb60d7af72e0d74353e10e6ae8258968965ce6befb442f736"
    end
  end

  def install
    bin.install "wd-bin"
    pkgshare.install "wd.zsh", "wd.bash", "wd.fish", "wd.ps1", "wd.nu"
  end

  def caveats
    <<~EOS
      Run first-time setup:

        wd-bin setup

      This detects your shell, installs the wrapper, and shows
      the exact line to add to your profile.

      Supported shells: zsh, bash, fish, PowerShell, Nushell
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wd-bin --version")
  end
end
