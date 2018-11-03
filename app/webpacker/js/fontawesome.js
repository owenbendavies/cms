import fontawesome from '@fortawesome/fontawesome';
import solid from '@fortawesome/fontawesome-free-solid';
import brands from '@fortawesome/fontawesome-free-brands';

fontawesome.library.add(solid);
fontawesome.library.add(brands);

document.addEventListener('turbolinks:load', () => {
  fontawesome.dom.i2svg();
});
