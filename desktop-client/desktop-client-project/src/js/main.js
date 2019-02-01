var app = new Vue({
  el: '#app',
  data: {
    mode: 'Files'
  },
  methods: {
    changeMode: function (mode) {
      this.mode = mode;
    }
  }
})