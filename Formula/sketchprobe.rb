# Homebrew formula for sketchprobe. It installs the prebuilt native executable from the GitHub Release:
# no Java, no compiling. Files installed by Homebrew are not quarantined by macOS, so there is no
# "unidentified developer" dialog (a direct download would need code signing, which is out of scope).
#
# The version in the URLs and the checksums below are filled in by packaging/homebrew/update-formula.sh from a
# release's SHA256SUMS; the release workflow attaches the result to the release as sketchprobe.rb.
class Sketchprobe < Formula
  desc "Inspect and decode Apache DataSketches binaries"
  homepage "https://github.com/yadavan88/sketchprobe"
  license "Apache-2.0"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/yadavan88/sketchprobe/releases/download/v0.1.1/sketchprobe-macos-arm64.tar.gz"
      sha256 "e7831e15aa29e4dacfce94116d597a2dd02ba4d1c82d6d914010b5600c04349d" # macos-arm64
    end
  end

  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/yadavan88/sketchprobe/releases/download/v0.1.1/sketchprobe-linux-x86_64.tar.gz"
      sha256 "de16f96bae852f6b0490d54104a35795d56bdd4ad54d3502544d3cc18d2c70e7" # linux-x86_64
    end
  end

  def install
    bin.install "sketchprobe"
    doc.install "LICENSE", "NOTICE"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sketchprobe --version")
    # An empty Frequency sketch (8 bytes), given as hex, is decoded and named.
    output = pipe_output("#{bin}/sketchprobe --input-format hex", "01010a0303050000")
    assert_match "Frequency", output
    # Empty input is refused with status 1.
    shell_output("#{bin}/sketchprobe < /dev/null", 1)
  end
end
