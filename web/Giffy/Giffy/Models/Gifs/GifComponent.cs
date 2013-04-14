using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;
using Giffy.Models.Interfaces;

namespace Giffy.Models.Gifs
{
    public class GifComponent : Model, ITrackable
    {
        #region Properties

        public virtual byte[] Image{ get; set; }
        public virtual int Order { get; set; }

        [ForeignKey("Builder")]
        public virtual int BuilderID { get; set; }
        public virtual GifBuilder Builder { get; set; }

        #endregion //Properties

        #region ITrackable Members

        public virtual DateTime CreatedOn { get; set; }
        public virtual DateTime UpdatedOn { get; set; }
        public virtual string CreatedBy { get; set; }
        public virtual string UpdatedBy { get; set; }

        #endregion //ITrackable Members
    }
}