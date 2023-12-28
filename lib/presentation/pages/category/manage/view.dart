import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_pilot/core/enums/state_status.dart';
import 'package:money_pilot/core/route/config.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/usecases/delete_category.dart';
import 'package:money_pilot/domain/usecases/filter_category_by_type.dart';
import 'package:money_pilot/presentation/bloc/category/category_bloc.dart';

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
    return DefaultTabController(
      length: _tabItems.length,
      child: Scaffold(
        appBar: _appbar,
        body: _content,
        floatingActionButton: _fab,
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
            .map((e) => BlocBuilder<CategoryBloc, CategoryState>(
                  bloc: context.read<CategoryBloc>(),
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
                          subtitle: Text('key: ${category.key ?? -1}'),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.more_vert_rounded),
                          ),
                          // trailing: Row(
                          //   mainAxisSize: MainAxisSize.min,
                          //   children: [
                          //     IconButton(
                          //       onPressed: () => {},
                          //       icon: Icon(Icons.edit_rounded),
                          //     ),
                          //     IconButton(
                          //       onPressed: () => {},
                          //       icon: Icon(Icons.delete_rounded),
                          //     ),
                          //   ],
                          // ),
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
}

class _TabItem {
  final String title;
  final CategoryType categoryType;
  _TabItem({
    required this.title,
    required this.categoryType,
  });
}
