using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using Giffy.Models;
using Giffy.Models.Interfaces;

namespace Giffy.Repositories
{
    public abstract class Repository<TModel>
        where TModel : Model
    {
        #region Fields

        private DbContext context;
        private DbSet<TModel> modelContainer;

        #endregion //Fields

        #region Properties

        public IQueryable<TModel> Models
        {
            get { return this.ModelContainer; }
        }

        protected DbContext Context
        {
            get 
            {
                if (this.context == null)
                    this.context = GetContext();

                return this.context;
            }
        }

        protected DbSet<TModel> ModelContainer
        {
            get
            {
                if (this.modelContainer == null)
                    this.modelContainer = GetModels();

                return this.modelContainer;
            }
        }

        #endregion //Properties

        #region Abstract Methods

        protected abstract DbContext GetContext();
        protected abstract DbSet<TModel> GetModels();
        protected virtual bool BeforeCreate(TModel model) { return true; }
        protected virtual bool BeforeUpdate(TModel model) { return true; }
        protected virtual bool BeforeDelete(TModel model) { return true; }

        #endregion //Abstract Methods

        #region Methods

        public TModel Get(int id)
        {
            return this.ModelContainer.Where(m => m.ID == id).SingleOrDefault();
        }

        public bool Create(TModel model)
        {
            AssignDataBeforeCreate(model);
            if (!BeforeCreate(model))
                return false;

            this.ModelContainer.Add(model);
            this.Context.SaveChanges();
            return true;
        }

        public bool Update(TModel model)
        {
            AssignDataBeforeUpdate(model);
            if (!BeforeUpdate(model))
                return false;

            this.Context.SaveChanges();
            return true;
        }

        public bool Delete(TModel model)
        {
            if (!BeforeDelete(model))
                return false;

            this.ModelContainer.Remove(model);
            this.Context.SaveChanges();
            return true;
        }

        #endregion //Methods

        #region Utilities

        private void AssignDataBeforeCreate(TModel model)
        {
            if (model is ITrackable)
            {
                var trackable = (ITrackable)model;
                var now = DateTime.Now;
                var userName = HttpContext.Current.User.Identity.Name;

                trackable.CreatedBy = userName;
                trackable.UpdatedBy = userName;
                trackable.CreatedOn = now;
                trackable.UpdatedOn = now;
            }
        }

        private void AssignDataBeforeUpdate(TModel model)
        {
            if (model is ITrackable)
            {
                var trackable = (ITrackable)model;
                var now = DateTime.Now;
                var userName = HttpContext.Current.User.Identity.Name;

                trackable.UpdatedBy = userName;
                trackable.UpdatedOn = now;
            }
        }

        #endregion //Utilities
    }
}