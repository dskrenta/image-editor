<image-editor>
  <img
    class="image" src={createImageUrl()}
    style="filter: saturate({image.filter.saturation}%) contrast({image.filter.contrast}%) brightness({image.filter.brightness}%);
    -webkit-filter: saturate({image.filter.saturation}%) contrast({image.filter.contrast}%) brightness({image.filter.brightness}%);"
  />

  <div class="menu">
    <div class="content-wrap">
      <button onclick={done}>Done</button>
      <form onchange={filterHandler}>
        <label>Brightness</label>
        <input type="range" data-type="brightness" value={image.filter.brightness} min="0" max="300"></input>
        <label>Saturation</label>
        <input type="range" data-type="saturation" value={image.filter.saturation} min="0" max="300"></input>
        <label>Contrast</label>
        <input type="range" data-type="contrast" value={image.filter.contrast} min="0" max="300"></input>
      </form>
      <button onclick={imageOverlay}>Image Overlay</button>
      <button onclick={textOverlay}>Text Overlay</button>
      <button onclick={crop}>Crop</button>
      <button onclick={reset}>Reset</button>
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
      background-color: #f8f8f8;
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
      filter: filterUndefined()
    };
    this.changed = false;
    const IMAGE_HEIGHT = 400;
    const self = this;

    createImageUrl () {
      return `http:\/\/topix.com/ipicimg/${self.image.id}-rszh${IMAGE_HEIGHT}`;
    }

    filterHandler (event) {
      self.changed = true;
      const value = event.target.value;
      const type = event.target.dataset.type;
      self.image.filter[type] = value;
    }

    function filterUndefined () {
      return {
        brightness: 100,
        saturation: 100,
        contrast: 100
      };
    }

    reset () {
      self.image.filter = filterUndefined();
      self.changed = false;
    }

    done () {
      if (self.changed) {
        console.log('changed');
      } else {
        console.log('unchanged');
      }
    }
  </script>
</image-editor>
