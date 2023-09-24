#!/usr/bin/env crystal
require "jennifer"

require "./config"
require "sam"
require "./db/migrations/*"

require "jennifer/sam"
require "jennifer/adapter/mysql"

load_dependencies "jennifer"

Sam.help
