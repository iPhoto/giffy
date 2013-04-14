using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Giffy.Models.Interfaces
{
    interface IDescribable
    {
        string Name { get; set; }
        string Description { get; set; }
    }
}
