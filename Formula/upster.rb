class Upster < Formula
  desc "CLI client for the local Upster control plane"
  homepage "https://github.com/kerddotdev/upster"
  version "1.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kerddotdev/upster/releases/download/v#{version}/upster-macos-arm64.tar.gz"
      sha256 "892fa54485c108403721187c954f7ea5ce840da0ff1f26c17a571e13357fad04"
    else
      url "https://github.com/kerddotdev/upster/releases/download/v#{version}/upster-macos-x64.tar.gz"
      sha256 "1dc0815c9e6b1219391eb8a05eeec7e1cd3b789f8ca3dc383ec06e1decdd4161"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kerddotdev/upster/releases/download/v#{version}/upster-linux-arm64.tar.gz"
      sha256 "5ba7bbb9123396454bab3a23ac9f7b6f3fedf1899935e77267af0e908d7ced57"
    else
      url "https://github.com/kerddotdev/upster/releases/download/v#{version}/upster-linux-x64.tar.gz"
      sha256 "ca53871bcdadeb4fbe9de764190bf7152bc4ae8d265ed42bcd12126323ee0813"
    end
  end

  def install
    bin.install "upster"
  end

  def caveats
    <<~CAVEATS
      Upster CLI is a client for a local Upster control plane (dashboard + libSQL)
      that you run with Docker:

        mkdir upster && cd upster
        curl -LO https://github.com/kerddotdev/upster/releases/latest/download/docker-compose.yaml
        curl -Lo .env https://github.com/kerddotdev/upster/releases/latest/download/env.example
        # edit .env, then:
        docker compose up -d
        upster auth setup

      Docs: upster --help  |  https://github.com/kerddotdev/upster
    CAVEATS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/upster --version")
  end
end
