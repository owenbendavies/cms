import { buildImagesQuery } from '../routes/images/build_images_query';
import { buildMessageQuery } from '../routes/messages/build_message_query';
import { buildPageQuery } from '../routes/pages/build_page_query';
import { buildSiteQuery } from '../routes/sites/build_site_query';

export const buildQuery = () => (fetchType, resource, params) => {
  switch (resource) {
    case 'images':
      return buildImagesQuery(fetchType, params);
    case 'messages':
      return buildMessageQuery(fetchType, params);
    case 'pages':
      return buildPageQuery(fetchType, params);
    case 'sites':
      return buildSiteQuery(fetchType, params);
    default:
      throw new Error(`Unkown resource ${resource}`);
  }
};
