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
    on_arm do
      url "https://github.com/yadavan88/sketchprobe/releases/download/v0.1.2/sketchprobe-macos-arm64.tar.gz"
      sha256 "6df1dab2bc2b618858c34dc86889a0e844893e045f775357a58f20e1c377c365" # macos-arm64
    end

    on_intel do
      url "https://github.com/yadavan88/sketchprobe/releases/download/v0.1.2/sketchprobe-macos-x86_64.tar.gz"
      sha256 "ccd224cd39df88bad647ecd8bb65ec27a6e0a75cef8f7ab5619c49031bbfb63d" # macos-x86_64
    end
  end

  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/yadavan88/sketchprobe/releases/download/v0.1.2/sketchprobe-linux-x86_64.tar.gz"
      sha256 "2e4878a16e7d6ae24095cac7111f0cf779ff8d9489aaaa86c281cf50ba9e620a" # linux-x86_64
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
