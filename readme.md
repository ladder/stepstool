# StepStool

![StepStool](https://raw.github.com/deliberatedata/stepstool/master/stepstool.png)

StepStool is a simple REST client for interacting with [Ladder](http://www.deliberatedata.com/). StepStool uses [Thor](https://github.com/wycats/thor) to act like a typical Unix command.

## Installation

Fork or download the Github repo to a folder on your local computer, and then execute:

    $ bundle

## Usage

Is the same as a regular Thor task, eg.

    $ thor list
    upload
    ------
    thor upload:auto URL PATH      # Upload files using auto-detection based on MIME-type
    thor upload:marc URL PATH      # Upload MARC files
    thor upload:marchash URL PATH  # Upload MARCHASH (JSON) files
    thor upload:marcxml URL PATH   # Upload MARCXML files
    thor upload:modsxml URL PATH   # Upload MODSXML files

For example, to upload a MARC file:

    $ thor upload:marc http://ladder.url /path/to/some/file.marc

Help on a command is available via Thor's help mechanism, eg.

    $ thor help upload:marc

JSON responses for each file uploaded will be sent to the terminal.

## Upload Options

* **Threads**: StepStool will use multiple threads to improve processing performance, at the cost of increased network traffic and load on the Ladder server.  By default, it will use the same number of threads as virtual CPU cores. Note that under MRI this will **not** use multiple cores.

* **Compress**: Enable client-side compression to reduce the amount of data actually sent to the server.  By default, three options are available:
    1. `gzip`: Slowest but best compression ratio.  This uses Ruby's built-in ZLib.
	2. `lz4`: Balance between speed and compression.  This requires the LZ4 gem to be installed (included by default).
	3. `snappy`: Fastest at the expense of least compression.  This requires the Snappy gem to be installed (included by default).

  Note that both `lz4` and `snappy` gems use C bindings, so may not work under JRuby, depending on your version and settings.

* **Map**: Tells Ladder to queue the uploaded file for mapping once it has completed uploading.  Depending on the size and complexity of the file, this may take a long time.  Ladder will return a `HTTP 202: Accepted` header to indicate that extended processing has started.

## MARC-in-JSON

StepStool will deliberately parse MARC and MARCXML files into individual records, and upload them individually re-encoded as MARC-in-JSON (aka [MARCHASH](http://dilettantes.code4lib.org/blog/2010/09/a-proposal-to-serialize-marc-in-json/)). This approach loses the "collection" aspect of the original file, but gains [numerous benefits](http://robotlibrarian.billdueber.com/new-interest-in-marc-hash-json/), including encoding normalization to UTF-8, more space efficiency, and better compressibility.  In addition, this approach trades some processing overhead on the client (which has to be done sequentially due to the nature of the MARC format) in exchange for much greater parallelism when mapping within Ladder.  If you *really* want to upload raw MARC or MARCXML, it's possible to do so manually.

Note that although StepStool *will* try to convert encodings such as ISO-8859-1 (Latin1) to UTF-8, due to limitations in [ruby-marc](https://github.com/ruby-marc/ruby-marc), it **cannot** transcode MARC files encoded in marc8. Garbage in, garbage out.

### TODO

* Gemify
* Add more endpoints
* Kill MARC once and for all, and usher in a golden age of library metadata