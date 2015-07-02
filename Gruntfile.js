module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    shell: {
      jekyll_build: {
        command: 'jekyll build'
      },
      // snip
    },
    // snip
    esteWatch: {
      options: {
        dirs: ['./', 'firewalls', '_layouts', '_includes'],
        livereload: {
          enabled: false
        }
      },
      '*': function(filepath) { return 'shell:jekyll_build' }
    }
  });

  grunt.loadNpmTasks('grunt-este-watch');

  grunt.registerTask('default', ['esteWatch']);
}
