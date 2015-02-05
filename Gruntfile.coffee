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

  grunt.registerTask 'test', [
    'coffee_jshint'
  ]

  grunt.registerTask 'default', ['test']
