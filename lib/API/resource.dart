class Resource<T>{
  late bool status;
  late T data;
  late String message = "";

  Resource(this.status, this.data, this.message);

  Resource.success(this.data, this.message,this.status){
    status = true;
  }

  Resource.error(this.data, this.message){
    status = false;
  }

  Resource.loading(this.data, this.message){
    status =false;
  }
}

// Status getStatus(int statusCode){
//   switch(statusCode){
//     case 200:
//       {
//         return Status.success;
//       }
//     default: {
//       return Status.error;
//     }
//   }
// }