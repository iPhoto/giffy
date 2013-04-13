using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using Giffy.Models;
using Giffy.Utilities;
using System.Net.Http.Formatting;
using ApiControllerBase = System.Web.Http.ApiController;

namespace Giffy.Controllers
{
    public abstract class ApiController : ApiControllerBase
    {
        private ModelContext models;

        protected ModelContext Models
        {
            get
            {
                if (this.models == null)
                {
                    this.models = new ModelContext();
                    this.models.Configuration.ProxyCreationEnabled = false;
                }

                return this.models;
            }
        }

        protected Device GetDevice()
        {
            return DeviceDetector.GetDevice(HttpContext.Current.Request);
        }

        protected ApiResult Success(IEnumerable<object> data)
        {
            if (data == null)
                throw new ArgumentNullException("data");

            return new ApiResult
            {
                Success = true,
                Data = data
            };
        }

        protected ApiResult Success(params object[] data)
        {
            return Success((IEnumerable<object>)data);
        }

        protected ApiResult Failure(string message)
        {
            return new ApiResult
            {
                Success = false,
                Data = new [] { message }
            };
        }
    }
}