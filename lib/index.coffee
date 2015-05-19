'use strict'

path = require 'path'
fs = require 'fs'
_ = require 'lodash'
less = require 'less'

# Apply custom bootstrap params from json
#
module.exports = (opts, done) ->
  opts = opts || {}

  bootstrapPath = require.resolve('bootstrap')

  bootstrapPath = path.resolve bootstrapPath, '../../../'
  bootstrapLessPath = path.join(bootstrapPath, 'less')

  # Transform bootstrap vars to JSON
  varsData = (->
    fileContent = fs.readFileSync path.join(bootstrapLessPath, 'variables.less'), encoding: 'utf8'
    lexemes = _.filter fileContent.split('\n'), (item) -> item.trim()[0] is '@'
    result = {}
    for item in lexemes
      splitItems = item.split /[:;]/
      key = splitItems.shift().trim()
      value = splitItems.shift().trim()
      result[key] = value
    result
  )()

  # Change vars with input data
  varsData = _.extend varsData, opts.variables ? {}

  imports = ((filename) ->
    data = fs.readFileSync(filename)
    pattern = /@import "([\w\.-]+)";/g
    while (match = pattern.exec(data))?
      match[1]
  )(path.join(bootstrapLessPath, 'bootstrap.less'))

  imports = _.filter imports, (importStr) ->  not(importStr in ['variables.less'])
  imports = _.map imports, (importStr) -> fs.readFileSync path.join(bootstrapLessPath, importStr), encoding: 'utf8'

  srcCode = imports.join('\n')
  varsData = _.values(_.transform(varsData, (result, value, key) -> result[key] = "#{ key }: #{ value };")).join('\n')
  srcCode = ([varsData].concat(imports)).join('\n')

  options =
    filename: path.join(bootstrapLessPath, 'bootstrap.less')
    compress: opts.compress ? true

  less.render(srcCode, options).then (output) ->
    fs.writeFileSync(opts.dest ? "bootstrap#{ if options.compress then 'min.' }.css", output.css) if opts.dest
    done?(output.css)
  .catch (err) ->
    console.log(err)
    done?(null, err)