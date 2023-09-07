//
// Created by Laky64 on 30/08/2023.
//

#include "shell_reader.hpp"

#ifdef BOOST_ENABLED
namespace ntgcalls {
    ntgcalls::ShellReader::ShellReader(const std::string &command) {
        try {
            shellProcess = bp::child(command, bp::std_out > stdOut);
        } catch (std::runtime_error &e) {
            throw ShellError(e.what());
        }
    }

    ShellReader::~ShellReader() {
        close();
    }

    void ShellReader::close() {
        BaseReader::close();
        stdOut.close();
        stdOut.pipe().close();
        shellProcess.wait();
    }

    wrtc::binary ShellReader::readInternal(size_t size) {
        if (eofInternal()) {
            return {};
        }
        auto *file_data = new uint8_t[size];
        stdOut.read(reinterpret_cast<char*>(file_data), size);
        readChunks += size;
        return file_data;
    }

    bool ShellReader::eofInternal() {
        return stdOut.eof();
    }
} // ntgcalls
#endif
