$LOAD_PATH.unshift(File.join(__dir__, "lib"))

require "yaml"
require "kyoko"

CONFIG_PATH = File.join(__dir__, "config.yml")

config = YAML.load_file(CONFIG_PATH)
Kyoko.new(config).run
