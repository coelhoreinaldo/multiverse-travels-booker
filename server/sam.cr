#!/usr/bin/env crystal
require "./config"
require "sam"
require "./db/migrations/*"
load_dependencies "jennifer"

Sam.help
