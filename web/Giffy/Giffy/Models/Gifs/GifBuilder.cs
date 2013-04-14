using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Giffy.Models.Interfaces;

namespace Giffy.Models.Gifs
{
    public class GifBuilder : Model, ITrackable
    {
        #region Properties

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
            return new GifContainer
            {
                Thumbnail = new byte[] { 1, 2, 3, 2, 255, 180, 121, 83, 2, 12, 21 },
                Gif = new byte[] { 4, 5, 6, 77, 81, 131, 12, 67, 155 }
            };
        }

        #endregion //Methods
    }
}