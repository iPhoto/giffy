using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Giffy.Models.Interfaces
{
    interface ITrackable
    {
        DateTime CreatedOn { get; set; }
        DateTime UpdatedOn { get; set; }
        string CreatedBy { get; set; }
        string UpdatedBy { get; set; }
    }
}
