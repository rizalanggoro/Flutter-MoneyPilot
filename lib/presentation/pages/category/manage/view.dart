import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_pilot/core/enums/state_status.dart';
import 'package:money_pilot/core/route/config.dart';
import 'package:money_pilot/core/route/params/category_create.dart';
import 'package:money_pilot/core/utils.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/usecases/delete_category.dart';
import 'package:money_pilot/domain/usecases/filter_category_by_type.dart';
import 'package:money_pilot/presentation/bloc/category/cubit.dart';

part 'cubit.dart';
part 'state.dart';

class PageCategoryManage extends StatefulWidget {
  const PageCategoryManage({super.key});

  @override
  State<PageCategoryManage> createState() => _PageCategoryManageState();
}

class _PageCategoryManageState extends State<PageCategoryManage> {
  final _tabItems = [
    _TabItem(
      title: 'Pemasukan',
      categoryType: CategoryType.income,
    ),
    _TabItem(
      title: 'Pengeluaran',
      categoryType: CategoryType.expense,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: BlocListener<CategoryManageCubit, CategoryManageState>(
        bloc: context.read<CategoryManageCubit>(),
        listener: (context, state) {
          if (state.type == StateType.delete) {
            if (state.status.isFailure) {
              Utils.showSnackbar(
                context: context,
                message: state.message,
              );
            }

            if (state.status.isSuccess) {
              if (state.deletedCategory != null) {
                context.read<CategoryCubit>().remove(
                      key: state.deletedCategory?.key ?? -1,
                    );
              }
            }
          }
        },
        child: DefaultTabController(
          length: _tabItems.length,
          child: Scaffold(
            appBar: _appbar,
            body: _content,
            floatingActionButton: _fab,
          ),
        ),
      ),
    );
  }

  get _appbar => AppBar(
        title: const Text('Kategori'),
        bottom: TabBar(
          tabs: _tabItems
              .map(
                (e) => Tab(
                  child: Text(e.title),
                ),
              )
              .toList(),
        ),
      );

  get _content => TabBarView(
        children: _tabItems
            .map((e) => BlocBuilder<CategoryCubit, CategoryState>(
                  bloc: context.read<CategoryCubit>(),
                  builder: (context, state) {
                    final categories = context
                        .read<CategoryManageCubit>()
                        .filterCategoriesByType(
                          categories: state.categories,
                          categoryType: e.categoryType,
                        );

                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return ListTile(
                          title: Text(category.name),
                          trailing: IconButton(
                            onPressed: () => _showBottomSheetCategoryOptions(
                              parentContext: context,
                              index: index,
                              category: category,
                            ),
                            icon: const Icon(Icons.more_vert_rounded),
                          ),
                        );
                      },
                      itemCount: categories.length,
                    );
                  },
                ))
            .toList(),
      );

  get _fab => FloatingActionButton(
        onPressed: () => context.push(Routes.categoryCreate),
        child: const Icon(Icons.add_rounded),
      );

  _showBottomSheetCategoryOptions({
    required BuildContext parentContext,
    required int index,
    required Category category,
  }) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(category.name),
          ),
          const Divider(
            indent: 16,
            endIndent: 16,
          ),
          ListTile(
            leading: const Icon(Icons.edit_rounded),
            title: const Text('Ubah'),
            onTap: () {
              context
                  .push(Routes.categoryCreate,
                      extra: RouteParamCategoryCreate(
                        category: category,
                      ))
                  .then((result) {
                if (result != null && result is Category) {}
              });
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_rounded),
            title: const Text('Hapus'),
            onTap: () {
              context.pop();
              _showDialogConfirmDelete(
                parentContext: parentContext,
                category: category,
              );
            },
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            child: OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('Batal'),
            ),
          ),
        ],
      ),
    );
  }

  void _showDialogConfirmDelete({
    required BuildContext parentContext,
    required Category category,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus kategori'),
        content: Text(
          'Apakah Anda yakin akan menghapus'
          ' kategori ${category.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              parentContext.read<CategoryManageCubit>().delete(
                    category: category,
                  );
              context.pop();
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

class _TabItem {
  final String title;
  final CategoryType categoryType;
  _TabItem({
    required this.title,
    required this.categoryType,
  });
}
