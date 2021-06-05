const main = () => {
  const notice = document.querySelector('.notice');
  const alert = document.querySelector('.alert');
  if (notice || alert) {
    setTimeout(() => {
      if (notice) {
        notice.classList.add('close');
        setTimeout(() => { notice.remove() }, 4000);
      }
      if (alert) {
        alert.classList.add('close');
        setTimeout(() => { alert.remove() }, 4000);
      }
    }, 10000);
  }
}

document.addEventListener('turbolinks:load', main);
