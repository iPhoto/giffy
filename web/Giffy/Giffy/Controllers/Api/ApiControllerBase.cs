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
using Giffy.Filters;

namespace Giffy.Controllers
{
    [ExceptionHandler]
    public abstract class ApiControllerBase : ApiController
    {
        protected Device GetDevice()
        {
            return DeviceDetector.GetDevice(HttpContext.Current.Request);
        }

        protected ApiResult<TResult> Success<TResult>(TResult data)
        {
            if (data == null)
                throw new ArgumentNullException("data");

            return new ApiResult<TResult>
            {
                Success = true,
                Data = data,
                Message = "Success"
            };
        }

        protected ApiResult<IEnumerable<TResult>> Success<TResult>(params TResult[] data)
        {
            return Success((IEnumerable<TResult>)data);
        }

        protected ApiResult<TResult> Failure<TResult>(string message)
        {
            return new ApiResult<TResult>
            {
                Success = false,
                Data = default(TResult),
                Message = message
            };
        }
    }
}