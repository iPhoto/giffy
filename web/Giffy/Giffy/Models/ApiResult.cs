using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Giffy.Models
{
    public class ApiResult
    {
        public bool Success { get; set; }
        public IEnumerable<object> Data { get; set; }
    }
}