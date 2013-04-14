using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Giffy.Models
{
    public class Authentication
    {
        [Key]
        public string UserName { get; set; }
        public string Token { get; set; }
    }
}