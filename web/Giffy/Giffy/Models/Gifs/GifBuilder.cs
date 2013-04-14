using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Giffy.Models.Interfaces;
using Giffy.Utilities;

namespace Giffy.Models.Gifs
{
    public class GifBuilder : Model, ITrackable
    {
        #region Properties

        public virtual string Name { get; set; }

        public virtual ICollection<GifComponent> Components { get; set; }

        #endregion //Properties

        #region ITrackable Members

        public virtual DateTime CreatedOn { get; set; }
        public virtual DateTime UpdatedOn { get; set; }
        public virtual string CreatedBy { get; set; }
        public virtual string UpdatedBy { get; set; }

        #endregion //ITrackable Members

        #region Methods

        public GifContainer Build()
        {
            var images =
                (from component in this.Components
                 orderby component.Order
                 select component.Image)
                .ToList();

            var imageBuilder =
                new GifImageBuilder()
                .AddImages(images);

            return new GifContainer
            {
                Thumbnail = imageBuilder.BuildThumbnail(),
                Preview = imageBuilder.BuildPreview(),
                Gif = imageBuilder.BuildGif(),
            };
        }

        #endregion //Methods
    }
}