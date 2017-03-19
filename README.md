# Usage
-------

Container wraps [Image Magik](http://www.imagemagick.org/) to perceptualy diif images

### Example 

Diff two images `img1.png` and `img2.png`

1. Create three folders `[ base, compare, result]`
2. Move `img1.png` to `base/img1.png`
3. Move `img2.png` to `compare/img1.png` **NOTE** For images to be compared the path / filename must match
4. Start the perceptual-diff container
```bash
docker run --rm -it -v "$(pwd)/base:/base" -v "$(pwd)/compare:/compare" -v "$(pwd)/result:/result" perceptual-diff
```
5. Inspect the `results.yaml` in the `result` folder 