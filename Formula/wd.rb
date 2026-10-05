class Wd < Formula
  desc "Workspace Director - fast project navigation CLI"
  homepage "https://github.com/kerddotdev/wd"
  version "1.4.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kerddotdev/wd/releases/download/v#{version}/wd-macos-arm64.tar.gz"
      sha256 "fb8f4ae2e7d30e990c4e9f9a6b73c335b95f89aea4522d69da65946c15df0247"
    else
      url "https://github.com/kerddotdev/wd/releases/download/v#{version}/wd-macos-x64.tar.gz"
      sha256 "70806255c9eada7eb247590193046d47a5cdbf0d5968822b82b117343d7bdc75"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kerddotdev/wd/releases/download/v#{version}/wd-linux-arm64.tar.gz"
      sha256 "146fc1522ccd886c54a7290a92eacf6966098ab21eb5b231d19222bfa99dbcab"
    else
      url "https://github.com/kerddotdev/wd/releases/download/v#{version}/wd-linux-x64.tar.gz"
      sha256 "89304d8dc06546100d7a1722b67275e75d9cbbc04bb6e5dcc9b43ca9dae74ec4"
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
