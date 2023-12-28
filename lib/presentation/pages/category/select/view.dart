import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/usecases/filter_category_by_type.dart';
import 'package:money_pilot/presentation/bloc/category/category_bloc.dart';

part 'cubit.dart';

class PageCategorySelect extends StatefulWidget {
  final Object? extra;
  const PageCategorySelect({
    super.key,
    this.extra,
  });

  @override
  State<PageCategorySelect> createState() => _PageCategorySelectState();
}

class _PageCategorySelectState extends State<PageCategorySelect> {
  final _tabItems = const [
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
    var initialIndex = 0;
    if (widget.extra != null && widget.extra is Category) {
      initialIndex = (widget.extra as Category).type.index;
    }

    return DefaultTabController(
      initialIndex: initialIndex,
      length: _tabItems.length,
      child: Scaffold(
        appBar: _appbar,
        body: _content,
      ),
    );
  }

  get _appbar => AppBar(
        title: const Text('Pilih kategori'),
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
                    var groupValue = -1;
                    if (widget.extra is Category) {
                      groupValue = (widget.extra as Category).key ?? -1;
                    }

                    final categories =
                        context.read<CategorySelectCubit>().filterByType(
                              categories: state.categories,
                              categoryType: e.categoryType,
                            );

                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return RadioListTile<int>(
                          groupValue: groupValue,
                          value: category.key ?? -1,
                          title: Text(category.name),
                          onChanged: (value) => context.pop(
                            category,
                          ),
                        );
                      },
                      itemCount: categories.length,
                      shrinkWrap: true,
                    );
                  },
                ))
            .toList(),
      );
}

class _TabItem {
  final String title;
  final CategoryType categoryType;
  const _TabItem({
    required this.title,
    required this.categoryType,
  });
}
