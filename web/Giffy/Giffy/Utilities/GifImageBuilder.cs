using System;
using System.Collections.Generic;
using System.Drawing;
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

        #endregion //Methods
    }
}