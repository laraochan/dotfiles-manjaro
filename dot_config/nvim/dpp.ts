import {
	BaseConfig,
	type ConfigArguments,
	type ConfigReturn,
} from "jsr:@shougo/dpp-vim@5.0.0/config";
import { type Toml } from "jsr:@shougo/dpp-ext-toml@2.0.1";
import { expand } from "jsr:@denops/std@8.0.0/function";

// TODO: tomlが一つのファイルにしか記述できない & dpp-ext-localに対応していないをどうにかする
export class Config extends BaseConfig {
	override async config(args: ConfigArguments): Promise<ConfigReturn> {
		args.contextBuilder.setGlobal({
			protocols: ["git"],
		});

		const [context, options] = await args.contextBuilder.get(args.denops);
		const toml: Toml = await args.dpp.extAction(
			args.denops,
			context,
			options,
			"toml",
			"load",
			{
				path: await expand(args.denops, "~/.config/nvim/dpp.toml")
			}
		);

		const tomlHooksFiles: string[] | undefined = [];
		if (toml.hooks_file !== undefined) {
			tomlHooksFiles.push(toml.hooks_file)
		}

		return {
			plugins: toml.plugins ?? [],
			ftplugins: toml.ftplugins,
			hooksFiles: tomlHooksFiles,
			multipleHooks: toml.multiple_hooks,
		}
	}
}
