const setupImageUpload = (form) => {
  let file = null;

  const url = "https://api.cloudinary.com/v1_1/chasscepts/image/upload";
  const wrapper = document.querySelector('#article-upload-wrapper');
  const imageUploadBtn = wrapper.querySelector('#image-upload-btn');
  const fileInput = wrapper.querySelector('#image-file-input');
  const nameSpan = wrapper.querySelector('#file-name');
  const acceptMimeTypes = ['image/png', 'image/jpg'];
  const loader = document.querySelector('#image-upload-loader');
  const supportsFileReader = window.FileReader && window.Blob;
  const setFileName = () => nameSpan.innerHTML = file? file.name : 'No File Selected';

  const getMimeType = (file) => {
    if (supportsFileReader) {
      return new Promise((resolve, reject) => {
        // https://stackoverflow.com/a/29672957
        const fileReader = new FileReader();
        fileReader.onloadend = function(e) {
          const arr = (new Uint8Array(e.target.result)).subarray(0, 4);
          let header = "";
          for(let i = 0; i < arr.length; i++) {
            header += arr[i].toString(16);
          }
          let type = '';
          switch (header) {
            case "89504e47":
              type = "image/png";
              break;
            case "47494638":
              type = "image/gif";
              break;
            case "ffd8ffe0":
            case "ffd8ffe1":
            case "ffd8ffe2":
            case "ffd8ffe3":
            case "ffd8ffe8":
              type = "image/jpeg";
              break;
            default:
              type = "unknown"; // Or you can use the blob.type as fallback
              break;
          }
          resolve(type);
        };
        fileReader.readAsArrayBuffer(file);
      });
    }
    return Promise.resolve(file.type);
  }

  fileInput.addEventListener('change', () => {
    file = fileInput.files && fileInput.files[0];

    if (file) {
      if (file.size > 2 * 1024 * 1024) {
        file = null;
        file = null;
        setFileName();
        alert('The file you is choose too large. The maximum allowed file size is 2MB');
        return;
      }

      getMimeType(file).then((type) => {
        if (acceptMimeTypes.indexOf(type) < 0) {
          file = null;
          alert('Please choose a PNG or JPEG image');
        }
        setFileName();
      });
    }
    else {
      setFileName();
    }
  });

  imageUploadBtn.addEventListener('click', () => {
    if (!file) {
      alert('Please choose a file to upload.');
      return;
    }

    loader.classList.add('open');
    const formData = new FormData();
    formData.append('file', file);
    formData.append("upload_preset", "chass_corner_client_uploads");
    fetch(url, {
      method: "POST",
      body: formData
    })
    .then((response) => {
      return response.text();
    })
    .then((data) => {
      const json = JSON.parse(data);
      document.querySelector('#article_image').value = json.secure_url
      loader.classList.remove('open');
      wrapper.classList.toggle('image-upload');
    })
    .catch(err => {
      loader.classList.remove('open');
      alert('An error occurred while uploading image. Please try again.')
    });
  });
}

const main = () => {
  const form = document.querySelector('#new_article_form');
  if (!form) {
    return;
  }
  setupImageUpload(form);
}

//document.addEventListener('turbolinks:load', main);
main();
