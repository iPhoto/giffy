using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Web;
using Giffy.Utilities.GifEncoding;

namespace Giffy.Utilities
{
    public class GifImageBuilder
    {
        #region Fields

        private List<byte[]> images = new List<byte[]>();
        private uint delay = 300;

        #endregion //Fields

        #region Methods

        public GifImageBuilder AddImages(params byte[][] images)
        {
            return AddImages((IEnumerable<byte[]>)images);
        }

        public GifImageBuilder AddImages(IEnumerable<byte[]> images)
        {
            foreach (var image in images)
                this.images.Add(image);

            return this;
        }

        public GifImageBuilder SetDelay(uint delay)
        {
            this.delay = delay;
            return this;
        }

        public byte[] BuildGif()
        {
            AnimatedGifEncoder encoder = new AnimatedGifEncoder();
            using (var memoryStream = new MemoryStream())
            {
                encoder.Start(memoryStream);
                encoder.SetDelay((int)this.delay);

                //-1:no repeat,0:always repeat
                encoder.SetRepeat(0);

                foreach (var image in images)
                    encoder.AddFrame(new Bitmap(new MemoryStream(image)));

                encoder.Finish();

                return memoryStream.ToArray();
            }
        }

        public byte[] BuildPreview()
        {
            return this.images.First();
        }

        public byte[] BuildThumbnail()
        {
            var preview = BuildPreview();
            var thumbnailBitmap = new Bitmap(new MemoryStream(preview));

            int maxDimension = 50;
            if (thumbnailBitmap.PhysicalDimension.Height > maxDimension ||
                thumbnailBitmap.PhysicalDimension.Width > maxDimension)
                thumbnailBitmap = ResizeThumbnail(thumbnailBitmap, maxDimension);

            return BitmapToByteArray(thumbnailBitmap);

        }

        #endregion //Methods

        #region Utilities

        private byte[] BitmapToByteArray(Bitmap bitmap)
        {
            byte[] byteArray = new byte[0];
            using (MemoryStream stream = new MemoryStream())
            {
                bitmap.Save(stream, ImageFormat.Bmp);
                stream.Close();

                byteArray = stream.ToArray();
            }
            return byteArray;
        }

        private Bitmap ResizeThumbnail(Bitmap bitmap, int maxDimension)
        {
            int width;
            int height;
            var dimensions = bitmap.PhysicalDimension;

            if (dimensions.Width > dimensions.Height)
            {
                var ratio = maxDimension / dimensions.Width;
                width = maxDimension;
                height = (int)Math.Floor(dimensions.Height * ratio);
            }
            else
            {
                var ratio = maxDimension / dimensions.Height;
                height = maxDimension;
                width = (int)Math.Floor(dimensions.Height * ratio);
            }

            return ResizeImage(bitmap, width, height);
        }

        public static Bitmap ResizeImage(Image image, int width, int height)
        {
            //a holder for the result 
            Bitmap result = new Bitmap(width, height);

            //use a graphics object to draw the resized image into the bitmap 
            using (Graphics graphics = Graphics.FromImage(result))
            {
                //set the resize quality modes to high quality 
                graphics.CompositingQuality = CompositingQuality.HighQuality;
                graphics.InterpolationMode = InterpolationMode.HighQualityBicubic;
                graphics.SmoothingMode = SmoothingMode.None;
                //draw the image into the target bitmap 
                graphics.DrawImage(image, 0, 0, result.Width, result.Height);
            }

            //return the resulting bitmap 
            return result;
        }

        #endregion //Utilities
    }
}