<editor>
  <img
    class="image"
    src={createImageUrl()}
    style="filter: saturate({image.filter.saturation}%) contrast({image.filter.contrast}%) brightness({image.filter.brightness}%);"
  />

  <div class="menu">
    <div class="content-wrap">
      <form onchange={handler}>
        <input type="range" data-type="brightness" value={image.filter.brightness} min="0" max="500"></input>
        <input type="range" data-type="saturation" value={image.filter.saturation} min="0" max="500"></input>
        <input type="range" data-type="contrast" value={image.filter.contrast} min="0" max="500"></input>
      </form>
    </div>
  </div>

  <style>
    .image {
      position: absolute;
      top: 0;
      bottom: 0;
      left: 0;
      right: 0;
      margin: auto;
    }
    .menu {
      float: right;
      vertical-align: middle;
      text-align: right;
      background-color: gray;
      height: 100%;
      width: 150px;
    }
    .content-wrap {
      margin-right: 1em;
      position: relative;
      top: 50%;
      transform: translateY(-50%);
    }
  </style>

  <script>
    this.image = {
      id: 'S5V10IJO9MAS1NJ1',
      filter: {
        brightness: 100,
        saturation: 100,
        contrast: 100
      }
    };
    const IMAGE_HEIGHT = 400;
    const self = this;

    createImageUrl () {
      return `http:\/\/topix.com/ipicimg/${self.image.id}-rszh${IMAGE_HEIGHT}`;
    }

    handler (event) {
      const value = event.target.value;
      const type = event.target.dataset.type;
      self.image.filter[type] = value;
      self.update();
      console.log(JSON.stringify(self.image));
    }
  </script>
</editor>
