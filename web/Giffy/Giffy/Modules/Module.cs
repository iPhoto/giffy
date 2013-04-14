using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Giffy.Models;
using Giffy.Utilities;

namespace Giffy.Modules
{
    public class Module
    {
        public UsersContext UserModels
        {
            get { return RequestData.Instance.UserModels; }
        }

        public ModelContext Models
        {
            get { return RequestData.Instance.Models; }
        }
    }
}