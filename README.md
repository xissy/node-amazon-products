# node-amazon-products
> A node.js module to crawl product IDs from Amazon.

Amazon Product Advertising API can access pages which are between 1 to 10 only. Using this module you can retrieve pages between 1 to 400 like an Amazon product list page.

## Installation
Via [npm](https://npmjs.org):

    $ npm install amazon-products


## Usage

### Load in the module
```javascript
var AmazonProducts = require('amazon-products');
```

### Get product IDs from an product list page url
```javascript
AmazonProducts.getProductIds({
  url: 'PRODUCT_LIST_PAGE_URL'
}, function(err, productIds) {
  ...
});
```
**INFO**: If the product list page has the next page link then all next pages will be reflected automatically until the next button is not appeared.

### Get product details
```javascript
AmazonProducts.getProductDetail({
  url: 'PRODUCT_DETAIL_PAGE_URL'
}, function(err, productDetail) {
  ...
});
```

## License

Released under the MIT License

Copyright (c) 2013 Taeho Kim <xissysnd@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
