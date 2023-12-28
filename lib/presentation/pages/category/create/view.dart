import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_pilot/core/enums/state_status.dart';
import 'package:money_pilot/core/utils.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/usecases/create_category.dart';
import 'package:money_pilot/presentation/bloc/category/category_bloc.dart';

part 'cubit.dart';
part 'state.dart';

class PageCategoryCreate extends StatefulWidget {
  const PageCategoryCreate({super.key});

  @override
  State<PageCategoryCreate> createState() => _PageCategoryCreateState();
}

class _PageCategoryCreateState extends State<PageCategoryCreate> {
  final TextEditingController _textEditingControllerName =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Buat kategori'),
        ),
        body: BlocListener<CategoryCreateCubit, CategoryCreateState>(
          bloc: context.read<CategoryCreateCubit>(),
          listener: (context, state) {
            if (state.type == StateType.create) {
              if (state.status.isSuccess) {
                context.pop();
              } else if (state.status.isFailure) {
                Utils.showSnackbar(
                  context: context,
                  message: state.message,
                );
              }
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: TextField(
                  controller: _textEditingControllerName,
                  decoration: const InputDecoration(
                    filled: true,
                    label: Text('Masukkan nama kategori'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 24,
                  bottom: 8,
                ),
                child: Text(
                  'Tipe kategori',
                  style: Utils.textTheme(context).titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              BlocBuilder<CategoryCreateCubit, CategoryCreateState>(
                bloc: context.read<CategoryCreateCubit>(),
                buildWhen: (previous, current) =>
                    current.type == StateType.categoryTypeChanged,
                builder: (context, state) => Column(
                  children: [
                    _NewCategoryType(
                      title: 'Pemasukan',
                      type: CategoryType.income,
                    ),
                    _NewCategoryType(
                      title: 'Pengeluaran',
                      type: CategoryType.expense,
                    ),
                  ]
                      .map(
                        (e) => RadioListTile<CategoryType>(
                          value: e.type,
                          groupValue: state.selectedCategoryType,
                          title: Text(e.title),
                          onChanged: (value) => context
                              .read<CategoryCreateCubit>()
                              .changeSelectedCategoryType(
                                newType: e.type,
                              ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  right: 16,
                  top: 16,
                ),
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () => context.read<CategoryCreateCubit>().create(
                        name: _textEditingControllerName.text,
                      ),
                  child: const Text('Selesai'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewCategoryType {
  final String title;
  final CategoryType type;

  _NewCategoryType({
    required this.title,
    required this.type,
  });
}
