class LlvmAT7 < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"
  url "https://github.com/llvm-mirror/llvm.git",
    :branch   => "release_70",
    :revision => "dd3329aeb25d87d4ac6429c0af220f92e1ba5f26"
  version "7.1.0"

  bottle do
    cellar :any
    rebuild 1
    sha256 "71636f7639720777e3e26c6d06456706cc79ad9bac08ba9d9100becfb903b210" => :mojave
    sha256 "acd6bae928b7a8d339b500e1571bc691e2bcfabfd08b6c9c74ff6ef962a2bbe4" => :high_sierra
    sha256 "e240000e773bbd10c9aac0eba8b510137a43929100b20b56e440ebca14dc7276" => :sierra
  end

  # Clang cannot find system headers if Xcode CLT is not installed
  pour_bottle? do
    reason "The bottle needs the Xcode CLT to be installed."
    satisfy { MacOS::CLT.installed? }
  end
    

  depends_on "cmake" => :build
  depends_on "libffi"

  def install
    ENV.libcxx if ENV.compiler == :clang
    ENV.permit_arch_flags

    args = %W[
      -DLLVM_TARGETS_TO_BUILD='host'
      -DLLVM_BUILD_TOOLS=false
      -DLLVM_ENABLE_RTTI=1
      -DCMAKE_BUILD_TYPE=Release
    ]

    mkdir "build" do
      system "cmake", "-G", "Unix Makefiles", "..", *(std_cmake_args + args)
      system "make -j#{ENV.make_jobs}"
      system "make", "install"
    end
    (share/"cmake").install "cmake/modules"
  end
end