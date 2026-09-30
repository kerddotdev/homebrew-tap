class Upster < Formula
  desc "CLI client for the local Upster control plane"
  homepage "https://github.com/kerddotdev/upster"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kerddotdev/upster/releases/download/v#{version}/upster-macos-arm64.tar.gz"
      sha256 "41b7b4e95573ce91392091410feec04aab5a5f9ac8f0ff3d4df07ee73c684e29"
    else
      url "https://github.com/kerddotdev/upster/releases/download/v#{version}/upster-macos-x64.tar.gz"
      sha256 "8d43b419246d7f89b99968627575cee927fab766a0c7f61dbfdd870f4e5c2b75"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kerddotdev/upster/releases/download/v#{version}/upster-linux-arm64.tar.gz"
      sha256 "e1ea3b97c96ae5147db4a9429372d3ee49001c787311231011fc15d389375819"
    else
      url "https://github.com/kerddotdev/upster/releases/download/v#{version}/upster-linux-x64.tar.gz"
      sha256 "1a755ca331cdad5b37c4bfb781ea8f04d048830e65e23f24fc2b6c19d1543cd2"
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
