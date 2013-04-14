using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Giffy.Models
{
    public class ApiResult<TResult>
    {
        public bool Success { get; set; }
        public TResult Data { get; set; }
        public string Message { get; set; }
    }
}