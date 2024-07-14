# Forma Jekyll Theme v1.1.0

[Theme Live Demo](https://forma.netlify.com/)

## Features

* Featured posts slider
* Masonry grid layout
* Contact form built-in 
* Mobile-ready
* Social icons built-in
* Social sharing built-in
* Mailchimp subscription form
* Code Syntax Highlight with [Prism.js](https://prismjs.com/)
* Support for Disqus comments

## Getting Started

**Table of Contents**

* 1. Theme Configuration
* 2. Author configuration
* 3. Social Links
* 4. Site Navigation
* 5. Images
* 6. Local Installation
* 7. Deployment
* 8. Support

### 1. Theme Configuration

The theme configuration options can be found within the **_config.yml** file. More information about Jekyll configuration can be found in the Jekyll documentation.

* name - the title of your blog, shown in the page and description areas.
* description - the description of your site for tagline, social meta tag, search engines, and feed.xml.
* site_description - the description of your site that will be used in the sidebar section. 
* logo - the image for site logo.
* favicon - the icon for your site.
* baseurl - the subpath of your site, e.g. /blog, for generating urls. If baseurl is set, you will need to prepend the baseurl to these settings: author image, site navigation, post images.
* production_url - the base hostname and protocol of your site for where absolute urls are needed.
* disqus - your Disqus shortname. Enter the Disqus shortname here if you wish to have Disqus comments enabled, leave blank to disable comments.
* mailchimp_url - your form action URL for MailChimp newsletter signup form.
* ga_analytics - Google analytics tracking ID.


### 2. Author configuration

To set up single or multiple authors got to **_data directory** *(Forma/_data/authors.yml)* and edit exmaple information. Afte that you need to add your created author for example author: daniel to the front matter of your post.


### 3. Social Links

To enable social links on your blog simply enter your social profile username, for example, twitter: "justgoodthemes" . If a field is left blank, the social icon will not be shown.

### 4. Site Navigation

The site navigation can be found in the **_config.yml** file. To add a page to the site navigation simply add your new page in the markdown format (e.g. newpage.md) in the theme root folder. Next edit your navigation menu located in **_config.yml** file on line 26. To add a new item to the navigation you have to add the item name and url. For example:

~~~~
navigation:
- text: New Page
url: /newpage/
~~~~

### 5. Images

Images for pages are located in the forma/assets/images folder and images for posts are located in the forma/assets/images/posts directory.

#### Image With Caption

Within your blog posts you can include captions for images. This requires using some HTML markup.

The example below illustrates how to include an image with a caption in a blog post:

~~~~
{% include image-caption.html imageurl="/images/posts/Apple-Watch-In-Car.jpg" 
title="Apple Super" caption="supertest" %}
~~~~

Add the following code into your post/page markdown and change its attributes accordingly.

#### Full Width Image With Caption

To have wide images in posts or pages simply add #wide word with the hashtag at the end of image path like in the example below:

~~~~
{% include image-caption.html imageurl="/images/posts/Apple-Watch-In-Car.jpg#wide" 
title="Apple" caption="This is caption" %}
~~~~

Add the following code into your post/page markdown and change its attributes accordingly.

#### Image alignment

To align images left or right you have to use #left and #right words with the hashtag at the end of the image path. Please, check the example below:

~~~~
![My helpful screenshot]("/assets/screenshot.jpg#left")
~~~~

### 6. Local Instalation

To set up Jekyll on local machine please follow the official documentation that can be found here -> https://jekyllrb.com/docs/.

### 7. Deployment

Sites built using Jekyll can be deployed in a large number of ways due to the static nature of the generated output. Here are some of the most common ways:

#### Manual Deployment

Jekyll generates your static site to the **_site** directory by default. You can transfer the contents of this directory to almost any hosting provider to get your site live. Here are some manual ways of achieving this:

##### Netlify

This theme is prepared to be hosted on [Netlify](https://www.netlify.com/). All you need to do is create a new private repository on GitHub or GitLab. Upload the theme to the repository and link your repo to Netlify. Please check [this link](https://www.netlify.com/blog/2015/10/28/a-step-by-step-guide-jekyll-3.0-on-netlify/#step-2-link-to-your-github) with the step by step guidelines.

##### FTP

Most traditional web hosting providers let you upload files to their servers over FTP. To upload a Jekyll site to a web host using FTP, run the jekyll build command and copy the contents of the generated **_site** folder to the root folder of your hosting account. This is most likely to be the httpdocs or public_html folder on most hosting providers.

##### Amazon S3

If you want to host your site on Amazon S3, you can do so by using the [s3_website application](https://github.com/laurilehmijoki/s3_website). It will push your site to Amazon S3 where it can be served like any web server, dynamically scaling to almost unlimited traffic.

### 8. Support

The documentation included provides all the information you need to get started with the theme. However, if you have any questions you can email us at hello@justgoodthemes.com, and we will be happy to help you.

*Also, if you have any bug reports, or feature requests, please let us know!*
