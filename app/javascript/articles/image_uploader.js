const customizeDragAndDropEvents = (dropArea) => {
 const preventDefaults = (e) => {
    e.preventDefault()
    e.stopPropagation()
  }

  const highlight = (e) => {
    dropArea.classList.add('highlight')
  }

  const unhighlight = (e) => {
    dropArea.classList.remove('highlight')
  }

  ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
    dropArea.addEventListener(eventName, preventDefaults, false)
  });

  ['dragenter', 'dragover'].forEach(eventName => {
    dropArea.addEventListener(eventName, highlight, false)
  });

  ['dragleave', 'drop'].forEach(eventName => {
    dropArea.addEventListener(eventName, unhighlight, false)
  });
}


const getPreview = (wrapper) => {
  const preview = document.createElement('img');
  const canLoad = !!window.FileReader;

  let appended = false;

  return {
    load: (file) => {
      if (!canLoad) {
        return;
      }
      const reader = new FileReader();

      reader.addEventListener("load", function () {
        preview.src = reader.result;
        if (!appended) {
          wrapper.append(preview);
          appended = true;
        }
      }, false);
      reader.readAsDataURL(file);
    },
    clear: () => {
      if (!appended) {
        return;
      }
      preview.remove();
      appended = false;
    }
  }
}

const setupImageUpload = (form) => {
  let file = null;

  const url = "https://api.cloudinary.com/v1_1/chasscepts/image/upload";
  const wrapper = document.querySelector('#article-upload-wrapper');
  const imageUploadBtn = wrapper.querySelector('#image-upload-btn');
  const fileInput = wrapper.querySelector('#image-file-input');
  const nameSpan = wrapper.querySelector('#file-name');
  const fileLabel = wrapper.querySelector('#file-input-label');
  const acceptMimeTypes = ['image/png', 'image/jpeg'];
  const loader = document.querySelector('#image-upload-loader');
  const stepInfo = document.querySelector('#step-info');
  const preview = getPreview(document.querySelector('#preview-wrap'));
  const maxImageSize = 512 * 1024;
  const supportsFileReader = window.FileReader && window.Blob;
  const setFile = () => {
    if (file) {
      nameSpan.innerHTML = file.name;
      preview.load(file);
    } else {
      nameSpan.innerHTML = 'No File Selected';
      preview.clear();
    }
  }

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

  const fileChangeHandler = (files) => {
    file = files && files[0];

    if (file) {
      if (file.size > maxImageSize) {
        file = null;
        file = null;
        setFile();
        alert('The file you choose is too large. The maximum allowed file size is 500KB');
        return;
      }

      getMimeType(file).then((type) => {
        if (acceptMimeTypes.indexOf(type) < 0) {
          file = null;
          alert('Please choose a PNG or JPEG image');
        }
        setFile();
      });
    }
    else {
      setFile();
    }
  }

  customizeDragAndDropEvents(fileLabel);

  fileInput.addEventListener('change', () => fileChangeHandler(fileInput.files));

  fileLabel.addEventListener('drop', (e) => fileChangeHandler(e.dataTransfer && e.dataTransfer.files))

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
      stepInfo.innerHTML = 'Step 2 of 2';
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

main();
