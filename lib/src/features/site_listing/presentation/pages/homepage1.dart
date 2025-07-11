import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_app/src/core/services/token_storeage.dart';
import 'package:try_app/src/features/auth/presentation/pages/login_page_wrapper.dart';
import 'package:try_app/src/features/site_listing/presentation/cubit/site_listing_cubit.dart';
import '../../../../injection/injection_container.dart';

class Homepage1 extends StatefulWidget {
  const Homepage1({super.key});

  @override
  State<Homepage1> createState() => _Homepage1State();
}

class _Homepage1State extends State<Homepage1> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final access = sl<TokenStorage>().getAccessToken();
    print(access);
    final ref = sl<TokenStorage>().getRefreshToken();
    print(ref);
    context.read<SiteListingCubit>().getSiteListing();
  }

  @override
  // Widget build(BuildContext context) {
  //   return BlocConsumer(
  //     buildWhen:
  //         (previous, current) =>
  //             current is SiteListingLoading ||
  //             current is SiteListingSuccessfullyFetched ||
  //             current is SiteListingFailure,
  //     listenWhen: (previous, current) => current is SiteListingActionState,
  //     builder: (context, state) {
  //       if (state is SiteListingLoading) {
  //         return CircularProgressIndicator(color: Colors.amber);
  //       } else if (state is SiteListingSuccessfullyFetched) {
  //         return Scaffold(
  //           appBar: AppBar(
  //             actions: [
  //               IconButton(
  //                 icon: Icon(Icons.logout),
  //                 onPressed: () async {
  //                   await sl<TokenStorage>().clearTokens();
  //                   Navigator.of(context).pushReplacement(
  //                     MaterialPageRoute(
  //                       builder: (context) => LoginPageWrapper(),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ],
  //           ),
  //           body: Center(child: Text("This is homepage")),
  //         );
  //       } else if (state is SiteListingFailure) {
  //         return Text(state.errorMessage);
  //       } else {
  //         return Text("");
  //       }
  //     },
  //     listener: (context, state) => state is SiteListingActionState,
  //   );
  // }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await sl<TokenStorage>().clearTokens();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPageWrapper()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<SiteListingCubit, SiteListingState>(
        builder: (context, state) {
          if (state is SiteListingLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is SiteListingSuccessfullyFetched) {
            // print(state.siteListEntity.results[0].city);
            // return Center(child: Card(child: Column(
            //   children: [
            //     Text(state.siteListEntity.results[0].title),
            //     Text(state.siteListEntity.results[0].city)
            //   ],
            // ),));
           return  ListView.builder(itemCount: state.siteListEntity.count,itemBuilder: (context,index){
// return Card(child: Column(
//               children: [
//                 Text(state.siteListEntity.results[index].title),
//                 Text(state.siteListEntity.results[index].city)
//               ],
//             ),);
print(state.siteListEntity.results[index].mainImage);
return ListTile(leading: Image.network("https://images.unsplash.com/photo-1526779259212-939e64788e3c?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8ZnJlZSUyMGltYWdlc3xlbnwwfHwwfHx8MA%3D%3D "??state.siteListEntity.results[index].mainImage),title:Text(state.siteListEntity.results[index].title ),subtitle: Text((state.siteListEntity.results[index].city),),);
           });
          } else if (state is SiteListingFailure) {
            return Center(child: Column(
              children: [
                Text(state.errorMessage),
                ElevatedButton(onPressed: (){ context.read<SiteListingCubit>().getSiteListing();}, child: Text("Try Again"))
              ],
            ));
          } else {
            return Center();
          }
        },
      ),
    );
  }
}
