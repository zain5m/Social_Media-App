import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/social_layout.dart';
import 'package:social/modules/social_register/cubit/social_register_cubit.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/network/local/cach_helper.dart';

class SocialRegisterScreen extends StatelessWidget {
  SocialRegisterScreen({Key? key}) : super(key: key);

  var formkey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state) {
          if (state is SocialRegisterErrorState) {
            showToast(
              state: ToastState.ERROR,
              text: state.error,
            );
          }
          if (state is SocialCreateSccessState) {
            CacheHelper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => SocialLayout(),
                ),
                (route) => false,
              );
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => SocialLayout(),
                ),
                (route) => false);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTER',
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          'Register now to communicate with friendes',
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'pless enter your name';
                            }
                          },
                          label: "User Name",
                          prefix: Icons.person,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'pless enter your email address';
                            }
                          },
                          label: "Email Address",
                          prefix: Icons.email_outlined,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          siffix: SocialRegisterCubit.get(context).suffix,
                          ispassword:
                              SocialRegisterCubit.get(context).ispassword,
                          siffixpressed: () {
                            SocialRegisterCubit.get(context)
                                .changePasswordVisibility();
                          },
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'password is too short';
                            }
                          },
                          label: "Password",
                          prefix: Icons.lock_outline,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'pless enter your phone';
                            }
                          },
                          label: "Phone",
                          prefix: Icons.phone,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        state is! SocialRegisterLoadingState
                            ? defaultButton(
                                text: 'register',
                                function: () {
                                  if (formkey.currentState!.validate()) {
                                    SocialRegisterCubit.get(context)
                                        .userRegister(
                                            name: nameController.text,
                                            email: emailController.text,
                                            password: passwordController.text,
                                            phone: phoneController.text);
                                  }
                                },
                                isUpperCase: true,
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),

                        // ConditionalBuilder(
                        //   condition: state is! SocialRegisterLoadingState,
                        //   builder: (context) => defaultButton(
                        //     text: 'register',
                        //     function: () {
                        //       if (formkey.currentState!.validate()) {
                        //         SocialRegisterCubit.get(context).userRegister(
                        //             name: nameController.text,
                        //             email: emailController.text,
                        //             password: passwordController.text,
                        //             phone: phoneController.text);
                        //       }
                        //     },
                        //     isUpperCase: true,
                        //   ),
                        //   fallback: (context) => Center(
                        //     child: CircularProgressIndicator(),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
