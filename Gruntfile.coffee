'use strict';

module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig
    coffee_jshint:
      options:
        jshintrc: '.jshintrc'

      all: [
        'Gruntfile.coffee'
        'lib/*.coffee'
      ]

    # Push release tasks
    push:
      options:
        files: ['package.json']
        updateConfigs: ['pkg']
        commitMessage: 'Version %VERSION%'
        commitFiles: ['package.json']
        tagName: '%VERSION%'
        npm: true

  grunt.registerTask 'test', [
    'coffee_jshint'
  ]

  grunt.registerTask 'default', ['test']
