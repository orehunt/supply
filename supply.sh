#!/bin/zsh -l

coinlib_key=cc753985af5c69d4
ua='User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; rv:11.0) like Gecko'
cookie='Cookie: cf_clearance=e89ca3e75634b523746675316b376f2d8c50d37e-1536950570-1800-150'

## coins max supply
typeset -A m_supply algo_hash coin_name coin_algo

## based on a ryzen7 hashrate
algo_hash=(
    cn           550
    cn-rto       550
    cn-xtl       550
    cn-web       550
    cn-lite      2100
    cn-adap      2000
    cn-xao       280
    cn-heavy     245
    cn-saber     180
    cn-fast      1050
    cn-sfast     1150
    cn-xhv       240
    wildk        350000
    yespow       1300
    yescrypt     7150
    lyra2rev2    1950
    lyra2z       750000
    argon2d      1800
)

m_supply=(
    XMR   18400000
    AEON  18400000
    GRFT  1840000000
    IRD   25000000
    TUBE  1000000000
    XHV   18400000
    XFH   18400000
    LOKI  150000000
    TRTL  1000000000000
    XTL   21000000000
    XLC   54000000
    MSR   18500000
    LTHN  1118000000
    ARQ 50000000
    XMV 256000000
    BSM 1840000000
    RECL 18400000
    WOW 184470000
    CTL 1850000
    QRL 65000000
    CCX 200000000
    SAFEX 2150000000
    FRTY 42000000000
    XAO 84000000
    RTO 28000000
    XUN 85000000000
    XDN 8590000000
    BBS 184470000000
    MKT 300000000
    ITA 18000000
    ELYA 1000000000
    PARS 8590000000
    ETNC 21000000000
    TOKL 18400000
    TRIT 84000000
    PSTAR 120000000
    LNS 1000000000
    KEPL 200000000
    INTU 1000000000
    XAT 21000000000
    XPP 18400000
    XNV 18400000
    BLUR 9223300
    BBR 18450000
    WEB 1750000000
    KOTO 214160000
    WAVI 60000000
    AQUA 42000000
)

coin_name=(
    IRD   iridium
    XMR   monero
    AEON  aeon
    GRFT  graft
    TUBE  bittube
    XHV   haven+protocol
    XHF   freehaven
    LOKI  loki
    TRTL  turtle
    XTL   stellite
    XLC   leviarcoin
    MSR   masari
    LTHN lethean
    ARQ arqma
    XMV monerov
    BSM bitsum
    RECL recoal
    WOW wownero
    CTL citadel
    QRL quantum+r+l
    CCX conceal
    SAFEX safex
    FRTY fourtytwo
    XAO alloy
    RTO arto
    XUN ultranote
    XDN digitalnote
    BBS bbscoin
    MKT marketcash
    ITA italocoin
    ELYA elya
    PARS parsicoin
    ETNC electroneumclassic
    TOKL toklio
    TRIT triton
    LNS lines
    KEPL kepl
    INTU intucoin
    XAT catalyst
    XPP privatepay
    XNV nerva
    BLUR blur
    BBR boolberry
    WEB webchain
    KOTO koto
    WAVI wavi
    AQUA aquachain
)

coin_algo=(
    IRD cn-lite
    AEON cn-lite
    TRTL cn-lite
    XMR cn
    GRFT cn
    TUBE cn-saber
    XHV cn-xhv
    XFH cn-sfast
    LOKI cn-heavy
    XTL cn-xtl
    XLC cn
    MSR cn-fast
    LTHN cn
    ARQ cn-lite
    XMV cn
    BSM cn-lite
    RECL cn
    WOW cn
    CTL cn
    QRL cn
    CCX cn-fast
    SAFEX cn
    FRTY cn-lite
    XAO cn-xao
    RTO cn-rto
    XUN cn
    XDN cn
    BBS cn
    MKT cn
    ITA cn-heavy
    ELYA cn
    PARS cn
    ETNC cn
    TOKL cn
    TRIT cn-lite
    PSTAR cn-lite
    LNS cn
    KEPL cn-fast
    INTU cn-lite
    XAT cn
    XPP cn-fast
    XNV cn-adap
    BLUR cn-adap
    BBR wildk
    WEB cn-web
    KOTO yespow
    WAVI yespow
    AQUA argon2d
)

c_data_path=/tmp/.cache/c_data

## circulating supply of coin $1
get_supply(){
    local c_sup
    name=${coin_name[$1]}
    if [ "${m_supply[$1]}" = 0 ]; then
        c_sup=$(curl -s -X GET "https://api.coingecko.com/api/v3/coins/${name}?localization=0&sparkline=false" -H "accept: application/json" | jq '.market_data.circulating_supply' -r)
        [ "${c_sup}" = null ] &&
            c_sup=$(curl -s -X GET "https://www.coincalculators.io/api.aspx?name=${name}&hashrate=0&power=0&poolfee=0&powercost=0" | jq '.totalSupply')
        eval "m_supply[$1]=$c_sup"
    fi
}

## hasharte
get_hashrate() {
    curl -s -X GET "https://moneroblocks.info/api/get_stats" -H "$ua" -H "$cookie" | jq -r '.hashrate'
}

coin_data() {
    if ! find $c_data_path -mmin +30 -print &>/dev/null; then
    c_data=$(curl -s -X GET 'https://www.cryptunit.com/api/earningscustom/?hashrate[1]=550&hashrate[3]=550&hashrate[4]=2100&hashrate[5]=280&hashrate[6]=240&hashrate[7]=1000&hashrate[8]=180&hashrate[9]=550&hashrate[11]=28&dataavg=24h&volumefilter=') && echo "$c_data" > $c_data_path
    fi
}

coin_rewards_coincalculators() {
    name=${coin_name[$1]}
    algo=${coin_algo[$1]}
    hashr=${algo_hash[$algo]}
    [ -z "$name" ] && coin=$1
    curl -s -X GET "https://www.coincalculators.io/api.aspx?name=${name}&hashrate=${hashr}&power=0&poolfee=0&powercost=0" | jq '.rewardsInMonth'
}

## rewards for coin with ticker
coin_rewards_cryptounit(){
    cat "$c_data_path" | jq '.[].coins[] | select(.coin_ticker == "'"$1"'") | .reward_month_coins'
}

## miningpoolstats.stream
coin_rewards_pools() {
    name=${coin_name[$1]}
    algo=${coin_algo[$1]}
    hashr=${algo_hash[$algo]}

    fetch_data(){
        data=$(curl -k --compressed -s -X GET "$pool_url")
        net_diff=$(echo "$data" | jq '.network.difficulty')
        block_time=$(echo "$data" | jq '.config.coinDifficultyTarget')
        net_hash=$(qalc -t "$net_diff / $block_time")
    }

    # net_hash=$(curl -s -X GET "https://miningpoolstats.stream/data/${name}.json" | jq '.hashrate')
    case "$1" in
        "XLC")
            # pool_url="https://pool.leviar.io:8118/live_stats"
            pool_url="http://xlc.crypto-coins.club:8118/live_stats"
            ;;
        "RECL")
            pool_url="https://recoal.herominers.com/api/live_stats"
            ;;
        "CCX")
            pool_url="https://conceal.herominers.com/api/live_stats"
            ;;
        "SAFEX")
            pool_url="https://safex.herominers.com/api/live_stats"
            ;;
        "FRTY")
            pool_url="https://cnpools.dedyn.io:28119/live_stats"
            ;;
        "XUN")
            pool_url="http://alpha.ultranote.org:8117/live_stats"
            ;;
        "MKT")
            pool_url="https://mkt.ciapool.com/api/live_stats"
            ;;
        "ETNC")
            pool_url="http://etnc.baikalmine.com:9869/stats"
            ;;
        "TOKL")
            pool_url="http://51.38.184.159:8118/live_stats"
            ;;
        "PSTAR")
            pool_url="http://pool.pinkstarcoin.com:7111/live_stats"
            ;;
        "INTU")
            pool_url="http://pool.intucoin.com:8117/live_stats"
            ;;
        "XAT")
            pool_url="https://pool.catalyst.cash:8119/stats"
            ;;
        "XPP")
            pool_url="https://privatepay.herominers.com/api/live_stats"
            ;;
        "XNV")
            pool_url=""
            net_hash=$(curl -s -X GET "https://api.getnerva.org/gethashrate.php")
            reward_units=$(curl -s -X GET "https://api.getnerva.org/getreward.php")
            block_time=$(curl -s -X GET "https://api.getnerva.org/getinfo.php" | jq '.target')
            ;;
        "BLUR")
            pool_url=""
            # data=$(curl -s -X GET 'http://explorer.blur.cash/' -H "$ua" -H "$cookie" --compressed)
            data=$(curl -s -X GET 'http://explorer.blur.cash/api/networkinfo' -H "$ua" -H "$cookie" --compressed)
            emission_units=$(curl -s -X GET 'http://explorer.blur.cash/api/emission' -H "$ua" -H "$cookie" --compressed | jq '.data.coinbase')
            emission=$(qalc -t "$emission_units" / "$coin_units")
            net_hash=$(echo "$data" | jq '.data.hash_rate')
            block_time=$(echo "$data" | jq '.data.target')
            reward_units=$(printf '%d' $(qalc -t "(${m_supply[BLUR]}*$coin_units-$emission*10^12)*2^-20"))
            ;;
        "WEB")
            pool_url=""
            data=$(curl -s -X POST 'https://explorer.webchain.network/web3relay' --data '{ "action": "hashrate" }' -H "Content-Type: application/json")
            net_hash=$(echo "$data" | jq '.hashrate')
            block_time=$(echo "$data" | jq '.blockTime')
            reward_units=$(curl -s -X GET 'http://thetapool.com/api/blocks' | jq '.matured[0].reward' -r)
            coin_units=1000000000000000000
            ;;
        "KOTO")
            pool_url=""
            data=$(curl -s -X GET https://koto.mofumofu.me/api/stats)
            net_hash=$(echo "$data" | jq -r  '.pools.koto.poolStats.networkSols')
            block_time=60
            coin_units=100000000
            reward_units=100000000
            ;;
        "AQUA")
            data=$(curl -s 'https://explorer.aqua.signal2noi.se/stats' -H 'Content-Type: application/json' --data '{"action":"hashrates"}')
            net_hash=$(echo "$data" | jq '.hashrates[-1].instantHashrate' -r)
            block_time=$(echo "$data" | jq '.hashrates[-1].blockTime')
            reward_units=$(curl -s 'http://aqua.hashpool.eu:8080/api/blocks' | jq '.matured[0].reward' -r)
            coin_units=1000000000000000000
            ;;
        "XFH")
            pool_url="https://freehaven.xmining.pro/api/live_stats"
            ;;
        *)
            :
    esac
    if [ -n "$pool_url" ]; then
        ## get the data from the pool
        fetch_data
        ## get block reward
        coin_units=$(echo "$data" | jq '.config.coinUnits')
        reward_units=$(echo "$data" | jq '.lastblock.reward')
        [ "$reward_units" = null ] && reward_units=$(echo "$data" | jq '.network.reward')
    fi

    ## coin rewards per month
    coin_units=${coin_units:-1000000000000} ## default to 12 units
    block_reward=$(qalc -t "$reward_units / $coin_units")
    blocks_per_month=$(qalc -t "60 / $block_time * 24 * 30")
    [ -z "$net_hash" -o -z "$blocks_per_month" ] && exit 1
    qalc -t "( $hashr / $net_hash * $blocks_per_month ) * $block_reward"
}

coin_rewards_misc() {
    case "$1" in
        "WAVI")
            curl -s 'https://wavicalc.tk/php/get.php?h=1300' | tail -1 | jq -r '.profitCoins'
        ;;
        *)
            :
    esac
}

reward_factor(){
    get_supply $1
    [ -z "${m_supply[$1]}" ] && echo "coin max supply not available" && exit 1
    [ -z "$cr" ] && cr=$(coin_rewards_cryptounit $1)
    [ -z "$cr" -o "$cr" = 0 ] && cr=$(coin_rewards_coincalculators $1)
    [ -z "$cr" -o "$cr" = 0 ] && cr=$(coin_rewards_pools $1)
    [ -z "$cr" -o "$cr" = 0 ] && cr=$(coin_rewards_misc $1)
    [ -z "$cr" ] && echo "error fetching coins reward for $1" && exit 1
    str="$cr / ${m_supply[$1]} * 1000000"
    factor=$(qalc -t "$str")
    [ -n "$factor" ] && echo "$1 ${coin_algo[$1]} $factor" 
    cr=
}

if [ "$SHLVL" -gt 1 -a -n "$1" ]; then
    coin_data
    reward_factor $1
else
    for k in ${(@k)coin_name};do
        if [ "$k" != "BLUR" ]; then
            coin_data
            reward_factor $k
        fi
    done
    wait
fi

