<modal-editor>
  <button onclick={open} class={opts.modal-class || 'btn-open'}>
    <yield from="inner-button" />
  </button>

  <div if={show} class="overlay">
    <div class="content">
      <div class="body">
        <button class="btn-close" onclick={close}>Close</button>
        <yield from="inner-content" />
      </div>
    </div>
  </div>

  <style>
    .btn-close {
      float: right;
      right: 10px;
      top: 10px;
    }
    .btn-open {

    }
    .overlay {
      width: 100vw;
      height: 100vh;
      position: fixed;
      top: 0;
      left: 0;
      z-index: 2000;
      background-color: rgba(0,0,0,0.3);
    }
    .content {
      width: 95%;
      max-width: 740px;
      margin-top: 150px;
      margin-left: auto;
      margin-right: auto;
      background: white;
      vertical-align: middle;
      border-radius: 5px;
    }
    .body {
      padding: 1px 20px 15px;
    }
  </style>

  <script>
    const self = this;
    this.show = false;

    open () {
      self.show = true;
    }

    close () {
      self.show = false;
    }
  </script>
</modal-editor>
