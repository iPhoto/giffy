using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Giffy.Models.Interfaces;

namespace Giffy.Models.Gifs
{
    public class GifContainer : Model, ITrackable, IDescribable
    {
        #region Properties

        public virtual byte[] Thumbnail { get; set; }
        public virtual byte[] Preview { get; set; }
        public virtual byte[] Gif { get; set; }

        #endregion //Properties

        #region ITrackable Members

        public virtual DateTime CreatedOn { get; set; }
        public virtual DateTime UpdatedOn { get; set; }
        public virtual string CreatedBy { get; set; }
        public virtual string UpdatedBy { get; set; }

        #endregion //ITrackable Members

        #region IDescribableMembers

        public virtual string Name { get; set; }
        public virtual string Description { get; set; }

        #endregion //IDescribableMembers
    }

    public class GifContainerDescription
    {
        public int GifContainerID { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
    }
}