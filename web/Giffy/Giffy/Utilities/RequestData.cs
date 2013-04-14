using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Giffy.Models;

namespace Giffy.Utilities
{
    public class RequestData
    {
        public UsersContext UserModels
        {
            get
            {
                var models = HttpContext.Current.Items["UserModels"] as UsersContext;
                if (models == null)
                {
                    models = new UsersContext();
                    HttpContext.Current.Items["UserModels"] = models;
                }

                return models;
            }
        }

        public ModelContext Models
        {
            get
            {
                var models = HttpContext.Current.Items["Models"] as ModelContext;
                if (models == null)
                {
                    models = new ModelContext();
                    HttpContext.Current.Items["Models"] = models;
                }

                return models;
            }
        }

        private RequestData() { }

        private static RequestData instance;

        public static RequestData Instance
        {
            get 
            {
                if (instance == null)
                    instance = new RequestData();

                return instance;
            }
        }
    }
}