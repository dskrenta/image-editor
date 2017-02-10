<image-editor>
  <img class="image" id="previewImage" src={createImageUrl()} />

  <div class="menu">
    <div class="content-wrap">
      <button onclick={done}>Done</button>
      <form onchange={filter}>
        <label>Brightness</label>
        <input type="range" data-type="brightness" value={image.filter.brightness} min="0" max="300"></input>
        <label>Saturation</label>
        <input type="range" data-type="saturation" value={image.filter.saturation} min="0" max="300"></input>
        <label>Contrast</label>
        <input type="range" data-type="contrast" value={image.filter.contrast} min="0" max="300"></input>
      </form>
      <button onclick={imageOverlay}>Image Overlay</button>
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
  const socket = io('http://localhost:3000');
  this.image = 'S5V10IJO9MAS1NJ1';
  const handler = {
    set: (target, prop, value) => {
      target[prop] = value;
      // console.log(JSON.stringify(editObj));
      socket.emit('image.imageEditor', editObj);
      console.log('Send data to node-image-pipeline');
      return true;
    }
  };
  const editObj = new Proxy(defaults(), handler);
  const IMAGE_HEIGHT = 400;
  const self = this;

  filter (event) {
    const value = event.target.value;
    const type = event.target.dataset.type;
    editObj[type] = value;
  }

  crop (event) {
    editObj.crop = {
      width: 200,
      height: 150,
      x: 20,
      y: 20
    }
  }

  imageOverlay (event) {
    let tempArray = editObj.overlays;
    tempArray.push({
      image: 'http://proxy.topixcdn.com/ipicimg/MEA8SRTIVA7JE6SH-rszh100',
      x: 10,
      y: 10
    });
    editObj.overlays = tempArray;
  }

  createImageUrl () {
    return `http:\/\/topix.com/ipicimg/${self.image}-rszh${IMAGE_HEIGHT}`;
  }

  function defaults () {
    return {
      id: 'S5V10IJO9MAS1NJ1',
      brightness: 100,
      contrast: '+0',
      saturation: 100,
      overlays: []
    };
  }

  socket.on('image.imageEditor:then', function (data) {
    console.log(data);
    createImageFromBuffer(data);
    console.log('Got response from node-image-pipeline');
  });

  function createImageFromBuffer (data) {
    var blob = new Blob([data], {type: 'image/png'});
    var urlCreator = window.URL || window.webkitURL;
    var imageUrl = urlCreator.createObjectURL(blob);
    var img = document.getElementById('previewImage');
    img.src = imageUrl;
  }
  </script>
</image-editor>
