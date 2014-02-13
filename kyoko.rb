$LOAD_PATH.unshift(File.join(__dir__, "lib"))

require "dotenv"
require "yaml"
require "kyoko"

Dotenv.load

path   = File.join(__dir__, "config.yml")
config = YAML.load_file(path)
Kyoko.new(config).run
